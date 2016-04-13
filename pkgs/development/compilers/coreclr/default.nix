{ stdenv
, fetchFromGitHub
, which
, cmake
, clang_35
, llvmPackages_36
, libunwind
, gettext
, openssl
}:

stdenv.mkDerivation rec {
  name = "coreclr-${version}";
  version = "git-" + (builtins.substring 0 10 rev);
  rev = "8c70800b5e8dc5535c379dec4a6fb32f7ab5e878";

  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "coreclr";
    inherit rev;
    sha256 = "1galskbnr9kdjjxpx5qywh49400swchhq5f54i16kxyr9k4mvq1f";
  };

  buildInputs = [
    which
    cmake
    clang_35
    llvmPackages_36.llvm
    llvmPackages_36.lldb
    libunwind
    gettext
    openssl
  ];

  configurePhase = ''
    # Prevent clang-3.5 (rather than just clang) from being selected as the compiler as that's
    # not wrapped
    substituteInPlace src/pal/tools/gen-buildsys-clang.sh --replace "which \"clang-" "which \"clang-DoNotFindThisOne"

    # Prevent the -nostdinc++ flag to be passed to clang, which causes a compilation error
    substituteInPlace src/CMakeLists.txt --replace "if(NOT CLR_CMAKE_PLATFORM_DARWIN)" "if(FALSE)"

    patchShebangs build.sh
    patchShebangs src/pal/tools/gen-buildsys-clang.sh
  '';

  buildPhase = "./build.sh";

  installPhase = ''
    pushd bin/Product/Linux.x64.Debug/
    mkdir -v -p $out/bin
    cp -v coreconsole corerun crossgen $out/bin
    cp -rv lib $out
    cp -v *.so $out/lib
    cp -rv inc $out/include
    cp -rv gcinfo $out/include
    popd
  '';

  meta = {
    homepage = http://dotnet.github.io/core/;
    description = ".NET is a general purpose development platform";
    platforms = [ "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ obadz ];
    license = stdenv.lib.licenses.mit;
  };
}
