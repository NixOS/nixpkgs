{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rkm-codes";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "rkm_codes";
    tag = "v${version}";
    hash = "sha256-S1ng2eTR+dNg7TkkpLTtJvX105FOqCi2eiMdRaqQrVg=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ setuptools ];

  # this has a circular dependency on quantiphy
  preBuild = ''
    sed -i '/quantiphy/d' pyproject.toml
  '';

  # this import check will fail as quantiphy is imported by this package
  # pythonImportsCheck = [ "rkm_codes" ];

  # tests require quantiphy import
  doCheck = false;

  meta = with lib; {
    description = "QuantiPhy support for RKM codes";
    homepage = "https://github.com/kenkundert/rkm_codes/";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
