{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, lib
, pytestCheckHook
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "in-place";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "inplace";
    rev = "v${version}";
    hash = "sha256-85VLkCNiBdMnI9LbF/a/2fCsoQ0UgXb17pV8/EAb2PA=";
  };

  patches = [
    (fetchpatch {
      name = "remove-wheel-dependency-constraint.patch";
      url = "https://github.com/jwodder/inplace/commit/3b5910afc6764d7c563a3cab511336a246e23000.patch";
      hash = "sha256-ssePCVlJuHPJpPyFET3FnnWRlslLnZbnfn42g52yVN4=";
    })
  ];

  postPatch = ''
    substituteInPlace tox.ini --replace "--cov=in_place --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
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
