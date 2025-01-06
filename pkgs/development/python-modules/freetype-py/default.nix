{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  setuptools-scm,
  freetype,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "freetype-py";
  version = "2.1.0.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k62fx53qrv9nb73mpqi2r11wzbx41qfv5qppvh6rylywnrknf3n";
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

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "freetype" ];

  meta = with lib; {
    homepage = "https://github.com/rougier/freetype-py";
    description = "FreeType (high-level Python API)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
