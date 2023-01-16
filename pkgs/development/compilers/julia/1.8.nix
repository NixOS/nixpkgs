{ lib
, stdenv
, fetchurl
, callPackage
, which
, python3
, patchelf
, gfortran
, perl
, gnum4
, libxml2
, openssl
, unzip
, xcbuild
, darwin
}:

stdenv.mkDerivation rec {
  pname = "julia";
  version = "1.8.5";

  src = callPackage ./1.8-source.nix { };

  patches = [
    ./patches/1.8/0001-skip-building-doc.patch
    ./patches/1.8/0003-silence-unnecessary-warning.patch
  ];

  nativeBuildInputs = [
    which
    python3
    patchelf
    gfortran
    perl
    gnum4
    unzip
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
    darwin.DarwinTools
  ];

  buildInputs = [
    libxml2
    openssl
  ];

  unpackPhase = ''
    # Copy source from nix store, so we must update the permissions
    cp -r "$src/." .
    chmod -R +rw .
  '';

  postPatch = ''
    patchShebangs .
  '';

  preBuild = ''
    source_version=$(cat "$src/VERSION")
    if [ "$source_version" != "$version" ]; then
      echo "Version of source package '$src' ($source_version) does not equal version of this package ($version)!"
      exit 1
    fi
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    # Preserve modified times to prevent rebuild during installCheckPhase
    cp -rp . "$out/."

    runHook postInstall
  '';

  preFixup = ''
    build_dir=$PWD
    cd $out
    # The manifest files contain absolute reference paths to $build_dir/usr/share/julia/stdlib/
    # Preserve modified times to prevent rebuild during installCheckPhase
    find usr/manifest/ \
      -type f \
      -exec touch -r {} _ref \; \
      -exec sed -i "s|$build_dir|$out|g" {} \; \
      -exec touch -r _ref {} \;
    rm -f _ref

    # Rewrite all symlinks that point to $build_dir absolutely to point to $out relatively
    find . -type l -lname "*$build_dir*" -print0 | while read -d $'\0' l; do
      target="$(readlink "$l")";
      new_target=''${target/#"$build_dir"/"$out"};
      ln -snrfT "$new_target" "$l"
    done
  '';

  # Ensure the move-docs.sh hook doesn't move the doc/ directory to share/doc/
  forceShare = [ "dummy" ];

  makeFlags = [
    "prefix=$(out)"
    # workaround for https://github.com/JuliaLang/julia/issues/47989
    "USE_INTEL_JITEVENTS=0"
  ] ++ lib.optionals stdenv.isx86_64 [
    # https://github.com/JuliaCI/julia-buildbot/blob/master/master/inventory.py
    "JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)"
  ] ++ lib.optionals stdenv.isAarch64 [
    "JULIA_CPU_TARGET=generic;cortex-a57;thunderx2t99;armv8.2-a,crypto,fullfp16,lse,rdm"
  ];

  doInstallCheck = true;
  installCheckTarget = "testall";

  preInstallCheck = ''
    export HOME="$TMPDIR"
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
