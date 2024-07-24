{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rkm-codes";
  version = "0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "rkm_codes";
    rev = "refs/tags/v${version}";
    hash = "sha256-CkLLZuWcNL8sqAupc7lHXu0DXUXrX3qwd1g/ekyHdw4=";
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
