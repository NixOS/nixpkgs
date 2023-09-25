{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, setuptools
}:

buildPythonPackage rec {
  pname = "rkm-codes";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "rkm_codes";
    rev = "v${version}";
    hash = "sha256-r4F72iHxH7BoPtgYm1RD6BeSZszKRrpeBQccmT4wzuw=";
  };

  format = "pyproject";
  nativeBuildInputs = [
    flit-core
  ];
  propagatedBuildInputs = [
    setuptools
  ];

  # this has a circular dependency on quantiphy
  preBuild = ''
    sed -i '/quantiphy/d' ./setup.py
    sed -i '/pytest-runner/d' ./setup.py
  '';

  # this import check will fail as quantiphy is imported by this package
  # pythonImportsCheck = [ "rkm_codes" ];

  # tests require quantiphy import
  doCheck = false;

  meta = with lib; {
    description = "QuantiPhy support for RKM codes";
    homepage = "https://github.com/kenkundert/rkm_codes/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
