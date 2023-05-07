{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, substituteAll
, setuptools-scm
, freetype
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "freetype-py";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-itgRldL48zmrphcAzr+9d9760UnFH1m3WipeN4M64S4=";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      freetype = "${freetype.out}/lib/libfreetype${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ freetype ];

  preCheck = ''
    cd tests
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck =  [ "freetype" ];

  meta = with lib; {
    homepage = "https://github.com/rougier/freetype-py";
    description = "FreeType (high-level Python API)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
