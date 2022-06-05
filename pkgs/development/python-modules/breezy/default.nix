{ lib
, buildPythonPackage
, fetchPypi
, configobj
, patiencediff
, fastbencode
, fastimport
, dulwich
, launchpadlib
, testtools
, pythonOlder
, installShellFiles
}:

buildPythonPackage rec {
  pname = "breezy";
  version = "3.2.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GHpuRSCN0F2BdQc2cgyDcQz0gJT1R+xAgcVxJZVZpNU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    configobj
    fastbencode
    patiencediff
    fastimport
    dulwich
    launchpadlib
  ];

  checkInputs = [ testtools ];

  # There is a conflict with their `lazy_import` and plugin tests
  doCheck = false;

  # symlink for bazaar compatibility
  postInstall = ''
    ln -s "$out/bin/brz" "$out/bin/bzr"

    installShellCompletion --cmd brz --bash contrib/bash/brz
  '';

  pythonImportsCheck = [ "breezy" ];

  meta = with lib; {
    description = "Friendly distributed version control system";
    homepage = "https://www.breezy-vcs.org/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.marsam ];
  };
}
