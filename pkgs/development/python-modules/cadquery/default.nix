{ lib
, buildPythonPackage
, toPythonModule
, pythonOlder
, pythonAtLeast
, fetchFromGitHub
, pyparsing
, opencascade
, stdenv
, python
, cmake
, swig
, smesh
, freetype
, libGL
, libGLU
, libX11
, six
, pytest
, makeFontsConf
, freefont_ttf
, Cocoa
}:

let
  pythonocc-core-cadquery = toPythonModule (stdenv.mkDerivation {
    pname = "pythonocc-core-cadquery";
    version = "0.18.2";

    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = "pythonocc-core";
      # no proper release to to use, this commit copied from the Anaconda receipe
      rev = "701e924ae40701cbe6f9992bcbdc2ef22aa9b5ab";
      sha256 = "07zmiiw74dyj4v0ar5vqkvk30wzcpjjzbi04nsdk5mnlzslmyi6c";
    };

    nativeBuildInputs = [
      cmake
      swig
    ];

    buildInputs = [
      python
      opencascade
      smesh
      freetype
      libGL
      libGLU
      libX11
    ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

    propagatedBuildInputs = [
      six
    ];

    cmakeFlags = [
      "-Wno-dev"
      "-DPYTHONOCC_INSTALL_DIRECTORY=${placeholder "out"}/${python.sitePackages}/OCC"
      "-DSMESH_INCLUDE_PATH=${smesh}/include/smesh"
      "-DSMESH_LIB_PATH=${smesh}/lib"
      "-DPYTHONOCC_WRAP_SMESH=TRUE"
    ];
  });

in
  buildPythonPackage rec {
    pname = "cadquery";
    version = "2.0";

    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = pname;
      rev = version;
      sha256 = "1n63b6cjjrdwdfmwq0zx1xabjnhndk9mgfkm4w7z9ardcfpvg84l";
    };

    buildInputs = [
      opencascade
    ];

    propagatedBuildInputs = [
      pyparsing
      pythonocc-core-cadquery
    ];

    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ freefont_ttf ];
    };

    nativeCheckInputs = [
      pytest
    ];

    disabled = pythonOlder "3.6" || pythonAtLeast "3.8";

    meta = with lib; {
      description = "Parametric scripting language for creating and traversing CAD models";
      homepage = "https://github.com/CadQuery/cadquery";
      license = licenses.asl20;
      maintainers = with maintainers; [ costrouc marcus7070 ];
    };
  }
