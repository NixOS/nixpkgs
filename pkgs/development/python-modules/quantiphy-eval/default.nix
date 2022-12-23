{ lib
, buildPythonPackage
, fetchFromGitHub
, inform
, sly
}:

buildPythonPackage rec {
  pname = "quantiphy-eval";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "quantiphy_eval";
    rev = "v${version}";
    sha256 = "sha256-7VHcuINhe17lRNkHUnZkVOEtD6mVWk5gu0NbrLZwprg=";
  };

  format = "flit";
  propagatedBuildInputs = [
    inform
    sly
  ];

  # this has a circular dependency on quantiphy
  preBuild = ''
    sed -i '/quantiphy>/d' ./pyproject.toml
  '';

  # tests require quantiphy import
  doCheck = false;

  meta = with lib; {
    description = "QuantiPhy support for evals in-line";
    homepage = "https://github.com/KenKundert/quantiphy_eval/";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
