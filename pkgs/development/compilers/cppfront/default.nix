{ stdenv
, fetchFromGitHub
, lib
}:

stdenv.mkDerivation {
  pname = "cppfront";
  version = "unstable-2023-05-15";

  src = fetchFromGitHub {
    repo = "cppfront";
    owner = "hsutter";
    rev = "ebe5ebc11303b11d29d6d40d498372c2bea07abd";
    sha256 = "sha256-PtRmN2HsDC6byXWR2iFepvEg1KBNeIsYm/LKqlFlZ7Y=";
  };

  buildPhase = ''
    runHook preBuild
    $CXX source/cppfront.cpp -std=c++20 -o cppfront
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 cppfront $out/bin/cppfront
    cp -r include $out/include
    runHook postInstall
  '';

  meta =
    let
      inherit (lib) platforms licenses maintainers;
    in
    {
      platforms = platforms.all;
      description = "An experimental compiler from a potential C++ 'syntax 2' (Cpp2) to today's 'syntax 1' (Cpp1)";
      homepage = "https://github.com/hsutter/cppfront";
      license = licenses.cc-by-nc-nd-40;
      maintainers = [
        maintainers.adisbladis
      ];
    };
}
