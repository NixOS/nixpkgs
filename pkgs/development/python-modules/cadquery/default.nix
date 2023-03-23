{ lib
, buildPythonPackage
, toPythonModule
, pythonOlder
, pythonAtLeast
, fetchFromGitHub
, pyparsing
, opencascade
, opencascade-occt
, stdenv
, pandas
, path
, pybind11
, python
, rapidjson
, click
, cmake
, swig
, smesh
, freetype
, jinja2
, joblib
, libcxx
, libGL
, libGLU
, libX11
, logzero
, llvm
, clang
, libclang
, six
, toml
, toposort
, tqdm
, pytest
, makeFontsConf
, freefont_ttf
, pybindgen
, schema
, Cocoa
, vtk
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

  pywrap = buildPythonPackage rec {
    pname = "pywrap";
    version = "0.0.0"; # no version as such
    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = "pywrap";
      # no versioning. This version is used as a git submodule in OCP.
      rev = "f3bcde70fd66a2d884fa60a7a9d9f6aa7c3b6e16";
      sha256 = "QhAvJHV5tFq9bjKOzEpcudZNnmUmNVrJ+BLCZJhO31g=";
    };

    nativeBuildInputs = [
    ];

    buildInputs = [
      clang
      schema
      pandas
      toposort
      pyparsing
      path
      toml
      tqdm
      logzero
      jinja2
      joblib
      click
      pybind11
    ];

    propagatedBuildInputs = [
      # TODO needed otherwise you get errors importing logzero
      clang
      schema
      pandas
      toposort
      pyparsing
      path
      toml
      tqdm
      logzero
      jinja2
      joblib
      click
      pybind11
    ];
  };

  # TODO Can't build this!

  # TODO ? https://github.com/NixOS/nixpkgs/issues/84552
  # [W 230322 23:33:30 translation_unit:48] ./opencascade/Standard_Std.hxx:20:10: fatal error: 'type_traits' file not found
  # and
# /build/source/OCP/AIS.cpp:2223:181: error: no matches converting function 'Append' to type 'void (class AIS_ManipulatorObjectSequence::*)(const int&)'
#  2223 |              (void (AIS_ManipulatorObjectSequence::*)( const int &  ) ) static_cast<void (AIS_ManipulatorObjectSequence::*)( const int &  ) >(&AIS_ManipulatorObjectSequence::Append),
#       |                                                                                                                                                                                     ^
# In file included from /nix/store/8pwvarkinzvvq8lf3fayklh5hsmj62vm-opencascade-occt-7.7.0/include/opencascade/NCollection_HSequence.hxx:19,
#                  from /nix/store/8pwvarkinzvvq8lf3fayklh5hsmj62vm-opencascade-occt-7.7.0/include/opencascade/AIS_Manipulator.hxx:26,
#                  from /build/source/OCP/AIS.cpp:396:


  ocp = toPythonModule (stdenv.mkDerivation rec {
    pname = "OCP";
    # giving up on this version for now: the new version has CMake improvements
#     version = "7.6.3.0";
#
#     src = fetchFromGitHub {
#       owner = "CadQuery";
#       repo = "OCP";
#       rev = version;
#       sha256 = "sha256-43gM7vpVbSrStG1Fg36IKWgZvTIWgqd0C6vfm5iwQ4w=";
#     };
    version = "7.7.0.0";

    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = "OCP";
      rev = "690c394abf32617f0c044159ad8a89480d40b240";
      sha256 = "y4lq0tUY+t6gL2DgQq28uD8a1Cvj7dTUzyoyWAA4J4g=";
    };
    patches = [ ./patch_OCP_inheritpythonpath.patch ];

    nativeBuildInputs = [
      cmake

    ];

    buildInputs = [
      llvm
      vtk
      python
      pybindgen
      rapidjson
      clang
      libclang
      opencascade
      opencascade-occt
      #pywrap
    ];

    propagatedBuildInputs = [
      pywrap
      libcxx
    ];

    cmakeFlags = [
      #"-DPYTHONPATH=$PYTHONPATH"
      #"-DCXX_INCLUDES='-i ${libcxx}'"
    ];
  });

in
  buildPythonPackage rec {
    pname = "cadquery";
    version = "2.2.0";

    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = pname;
      rev = version;
      sha256 = "KzwPD+bhCHFiLVAVLn9cLsVke/N3PTh7d2pAzuPeHKI=";
    };

    buildInputs = [
      opencascade
    ];

    propagatedBuildInputs = [
      pyparsing
      ocp
    ];

    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ freefont_ttf ];
    };

    nativeCheckInputs = [
      pytest
    ];

    disabled = pythonOlder "3.8" || pythonAtLeast "3.11";

    meta = with lib; {
      description = "Parametric scripting language for creating and traversing CAD models";
      homepage = "https://github.com/CadQuery/cadquery";
      license = licenses.asl20;
      maintainers = with maintainers; [ costrouc marcus7070 ];
    };

    passthru = {
      inherit ocp pywrap;
    };
  }
