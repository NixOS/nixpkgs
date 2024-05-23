{
  lib,
  buildPythonPackage,
  fetchFromBitbucket,
  h5py,
  termcolor,
  pexpect,
  jinja2,
  sphinxHook,
  sphinx-rtd-theme,
}:

buildPythonPackage {
  pname = "pylion";
  version = "0.5.3";
  format = "setuptools";

  src = fetchFromBitbucket {
    owner = "dtrypogeorgos";
    repo = "pylion";
    # Version is set in setup.cfg, but not in a git tag / bitbucket release
    rev = "3e6b96b542b97107c622d66b0be0551c3bd9f948";
    hash = "sha256-c0UOv2Vlv9wJ6YW+QdHinhpdaclUh3As5TDvyoRhpSI=";
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
