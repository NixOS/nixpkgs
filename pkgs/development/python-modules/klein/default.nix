{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,
  wheel,

  # dependencies
  attrs,
  hyperlink,
  incremental,
  tubes,
  twisted,
  werkzeug,
  zope-interface,

  # tests
  idna,
  python,
  treq,
}:

buildPythonPackage rec {
  pname = "klein";
  version = "unstable-2023-09-05";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twisted";
    repo = pname;
    rev = "44b356ede27a667252ae5392014c802f0492c017";
    hash = "sha256-zHdyyx5IseFWr25BGLL0dDM8/5BDehsvbxIci+DEo9s=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    attrs
    hyperlink
    incremental
    twisted
    tubes
    werkzeug
    zope-interface
  ];

  nativeCheckInputs = [
    idna
    treq
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m twisted.trial klein
    runHook postCheck
  '';

  pythonImportsCheck = [ "klein" ];

  meta = with lib; {
    changelog = "https://github.com/twisted/klein/releases/tag/${version}";
    description = "Klein Web Micro-Framework";
    homepage = "https://github.com/twisted/klein";
    license = licenses.mit;
    maintainers = with maintainers; [ exarkun ];
  };
}
