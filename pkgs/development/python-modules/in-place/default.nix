{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "in-place";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "inplace";
    rev = "v${version}";
    sha256 = "1w6q3d0gqz4mxvspd08l1nhsrw6rpzv1gnyj4ckx61b24f84p5gk";
  };

  postPatch = ''
    substituteInPlace tox.ini --replace "--cov=in_place --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "in_place" ];

  meta = with lib; {
    description = "In-place file processing";
    homepage = "https://github.com/jwodder/inplace";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
