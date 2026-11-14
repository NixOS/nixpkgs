{
  buildDunePackage,
  windtrap,
  ppxlib,
}:

buildDunePackage {
  pname = "ppx_windtrap";
  inherit (windtrap) version src;

  minimalOCamlVersion = "5.3";

  propagatedBuildInputs = [
    windtrap
    ppxlib
  ];

  doCheck = true;

  # skip “collapse_home” tests, because $HOME ≠ getpwuid in the sandbox
  preCheck = ''
    unset HOME
  '';

  meta = windtrap.meta // {
    description = "PPX and instrumentation backend for windtrap";
  };
}
