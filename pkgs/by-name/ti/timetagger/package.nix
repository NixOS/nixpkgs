{
  lib,
  python3,
  callPackage,

  addr ? "127.0.0.1",
  port ? 8082,
}:

#
# Timetagger itself is a library that a user must write a "run.py" script for
# We provide a basic "run.py" script with this package, which simply starts
# timetagger.
#

python3.pkgs.buildPythonApplication (finalAttrs: {
  inherit (python3.pkgs.timetagger)
    pname
    version
    src
    meta
    ;

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    timetagger
  ];

  installPhase = ''
    mkdir -p $out/bin
    echo "#!${python3.interpreter}" >> $out/bin/timetagger
    cat timetagger/__main__.py >> $out/bin/timetagger
    chmod +x $out/bin/timetagger
    wrapProgram $out/bin/timetagger \
      --set TIMETAGGER_BIND "${finalAttrs.passthru.addr}:${toString finalAttrs.passthru.port}"
  '';

  passthru = (python3.pkgs.timetagger.passthru or { }) // {
    services.default = {
      imports = [ (lib.modules.importApply ./service.nix { timetagger = finalAttrs.finalPackage; }) ];
    };
    tests = callPackage ./tests.nix { };
    # can't use override on finalAttrs.finalPackage?
    inherit port addr;
  };
})
