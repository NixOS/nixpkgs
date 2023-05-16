<<<<<<< HEAD
{ stdenv, lib, jekyll, cmake, fetchFromGitHub, gtest }:
=======
{ stdenv, lib, jekyll, fetchFromGitHub }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "jsonnet";
  version = "0.20.0";
<<<<<<< HEAD
  outputs = [ "out" "doc" ];
=======
  outputs = ["out" "doc"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "sha256-FtVJE9alEl56Uik+nCpJMV5DMVVmRCnE1xMAiWdK39Y=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ jekyll cmake ];
  buildInputs = [ gtest ];

  cmakeFlags = [
    "-DUSE_SYSTEM_GTEST=ON"
    "-DBUILD_STATIC_LIBS=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DBUILD_SHARED_BINARIES=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  # https://github.com/google/jsonnet/issues/778
  patches = [
    ./fix-cpp-unresolved-symbols.patch
  ];

  enableParallelBuilding = true;

  # Upstream writes documentation in html, not in markdown/rst, so no
  # other output formats, sorry.
  postBuild = ''
    jekyll build --source ../doc --destination ./html
  '';

  postInstall = ''
    mkdir -p $out/share/doc/jsonnet
=======
  nativeBuildInputs = [ jekyll ];

  enableParallelBuilding = true;

  makeFlags = [
    "jsonnet"
    "jsonnetfmt"
    "libjsonnet.so"
  ];

  # Upstream writes documentation in html, not in markdown/rst, so no
  # other output formats, sorry.
  preBuild = ''
    jekyll build --source ./doc --destination ./html
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include $out/share/doc/jsonnet
    cp jsonnet $out/bin/
    cp jsonnetfmt $out/bin/
    cp libjsonnet*.so $out/lib/
    cp -a include/*.h $out/include/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cp -r ./html $out/share/doc/jsonnet
  '';

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ benley copumpkin ];
    license = lib.licenses.asl20;
    homepage = "https://github.com/google/jsonnet";
    platforms = lib.platforms.unix;
  };
}
