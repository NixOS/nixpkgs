{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, numpy }:

buildPythonPackage rec {
  pname = "jsonconversion";
  version = "0.2.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4hMY0N/Px+g5zn3YzNfDWPyi8Pglvd/c2N9SeC4JoZ0=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'" ""
  '';

  checkInputs = [ pytestCheckHook numpy ];

  pythonImportsCheck = [ "jsonconversion" ];

  meta = with lib; {
    description = "This python module helps converting arbitrary Python objects into JSON strings and back";
    homepage = "https://pypi.org/project/jsonconversion/";
    license = licenses.bsd2;
    maintainers = [ maintainers.terlar ];
  };
}
