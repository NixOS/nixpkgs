# -*- shell-script -*-
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

function extract
{
    printf "extracting $(basename $1) ...\n"
    local tarflags="xf"

    case "$1" in
        *.tar.xz)
        xz -dc $1 | tar "$tarflags" - ;;
    *)
        printf "Make sure you give a iPhoneOS9.2.sdk.tar.xz file \n" ;;
    esac
}

function verify_arch {
    case "$1" in
    # Our good arches.
    armv7|arm64) ;;
    *)
        local
        acc="armv7 | arm64"
        error_message=$(
        printf '%s is not an acceptable arch. Try one of %s' "$1" "$acc"
             )
        printf "$error_message\n"
        exit
    esac
}

function verify_sdk_version {
    sdk_version=$(basename "$1" | grep -P -o "[0-9].[0-9]+")
    case "$sdk_version" in
    # Make sure the SDK is correct.
    [5-9].[0-9]) ;;
    *)
        printf 'No iPhone SDK version in file name\n'
    esac
}

function do_build {

    if [ $# -lt 2 ]; then
    printf "usage: $0 iPhoneOS.sdk.tar* <target cpu>\n" 1>&2
    printf "i.e. $0 /path/to/iPhoneOS.sdk.tar.xz armv7\n" 1>&2
    exit 1
    fi

    mkdir -p $out

    chmod -R 755 "$cctools_port"

    pushd "$cctools_port"/usage_examples/ios_toolchain &> /dev/null

    export LC_ALL=C

    local
    triple='%s-apple-darwin11'
    target_dir="$PWD/target"
    sdk_dir="$target_dir/SDK"
    platform="$(uname -s)"
    # Will be mutated by verify_sdk_version
    sdk_version=

    mkdir -p "$target_dir"
    mkdir -p "$target_dir/bin"
    mkdir -p "$sdk_dir"

    verify_arch "$2"
    verify_sdk_version "$1"

    triple="$(printf "$triple" "$2")"
    pushd "$sdk_dir" &>/dev/null
    extract "$1"

    local sys_lib=$(
        find $sdk_dir -name libSystem.dylib -o -name libSystem.tbd | head -n1
          )

    if [ -z "$sys_lib" ]; then
        printf "SDK should contain libSystem{.dylib,.tbd}\n" 1>&2
        exit 1
    fi

    local sys_root=$(readlink -f "$(dirname $sys_lib)/../..")

    local sdk_unboxed=$(basename $sys_root)

    mv -f "$sys_root"/* "$sdk_dir" || true

    popd &>/dev/null

    printf "\nbuilding wrapper\n"

    printf "int main(){return 0;}" | clang -xc -O2 -o "$target_dir"/bin/dsymutil -

    clang -O2 -std=c99 $alt_wrapper \
          -DTARGET_CPU=$(printf '"%s"' "$2") \
          -DNIX_APPLE_HDRS=$(
        printf '"%s"' "-I$out/$sdk/usr/include"
          ) \
          -DNIX_APPLE_FRAMEWORKS=$(
        printf '"%s"' "$out/$sdk/System/Library/Frameworks"
          ) \
          -DNIX_APPLE_PRIV_FRAMEWORKS=$(
        printf '"%s"' "$out/$sdk/System/Library/PrivateFrameworks"
          ) \
          -DOS_VER_MIN=$(printf '"%s"' "7.1") \
          -o "$target_dir/bin/$triple-clang"

    pushd "$target_dir"/bin &>/dev/null

    cp "$triple"-clang "$triple"-clang++

    popd &>/dev/null

    printf "\nbuilding ldid\n"

    mkdir -p tmp
    pushd tmp &>/dev/null
    pushd "$ldid" &>/dev/null

    chmod -R 755 "$ldid"

    make INSTALLPREFIX="$target_dir" -j4 install
    popd &>/dev/null
    popd &>/dev/null

    printf "\nbuilding cctools / ld64\n"

    pushd ../../cctools &>/dev/null
    git clean -fdx . &>/dev/null || true
    ./autogen.sh
    ./configure --target="$triple" --prefix="$target_dir"
    make -j4
    make install &>/dev/null

    popd &>/dev/null

    local me=`whoami`

    for d in bin libexec SDK; do
        chown -R $me:$me target/$d
        cp -R target/$d $out
    done

    # Crucial piece
    rm -rf $out/$sdk
    mv $out/SDK $out/$sdk
}

do_build $src armv7
