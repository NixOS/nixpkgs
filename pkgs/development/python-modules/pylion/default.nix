{ lib
, buildPythonPackage
, fetchFromBitbucket
, h5py
, termcolor
, pexpect
, jinja2
, sphinxHook
, sphinx-rtd-theme
}:

buildPythonPackage {
  pname = "pylion";
  version = "0.5.2";
  format = "setuptools";

  src = fetchFromBitbucket {
    owner = "dtrypogeorgos";
    repo = "pylion";
    # Version is set in setup.cfg, but not in a git tag / bitbucket release
    rev = "8945a7b6f1912ae6b9c705f8a2bd521101f5ba59";
    hash = "sha256-4AdJkoQ1hAssDUpgmARGmN+ihQqRPPOncWJ5ErQyWII=";
  };

  # Docs are not available online, besides the article:
  # http://dx.doi.org/10.1016/j.cpc.2020.107187
  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  propagatedBuildInputs = [
    h5py
    termcolor
    pexpect
    jinja2
  ];

  pythonImportsCheck = [ "pylion" ];

  # Tests fail from some reason - some files seem to be missing from the repo.
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/doc/$name
    cp -r examples $out/share/doc/$name/examples
  '';

  meta = with lib; {
    description = "A LAMMPS wrapper for molecular dynamics simulations of trapped ions";
    homepage = "https://bitbucket.org/dtrypogeorgos/pylion";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
