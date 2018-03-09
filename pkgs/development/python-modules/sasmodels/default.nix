{fetchgit, licenses, buildPythonPackage, pytest, numpy, scipy, matplotlib, docutils}:

buildPythonPackage rec {
  name = "sasmodels-${version}";
  version = "0.96";

  propagatedBuildInputs = [docutils matplotlib numpy pytest scipy];

  preCheck = ''export HOME=$(mktemp -d)'';

  src = fetchgit {
    url = "https://github.com/SasView/sasmodels.git";
    rev = "v${version}";
    sha256 = "11qaaqdc23qzb75zs48fkypksmcb332vl0pkjqr5bijxxymgm7nw";
  };

  meta = {
    description = "Library of small angle scattering models";
    homepage = http://sasview.org;
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
