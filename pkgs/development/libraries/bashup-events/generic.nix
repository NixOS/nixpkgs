{
  # general
  lib
, callPackage
, runCommand
, resholvePackage
, bash
, shellcheck
, doCheck ? true
, doInstallCheck ? true
  # variant-specific
, variant
, version
, branch
, src
, fake ? false
, keep
}:
let
  # extracting this so that it's trivial to test in other shells
  installCheck = shell:
    ''
      echo "testing bashup.events in ${shell}"
      ${shell} <<'EOF'
      source $out/bin/bashup.events
      neat(){
        echo $0: Hi from event \'test event\'. I can have both $1 and $2 arguments.
        exit 0
      }
      event on "test event" @2 neat curried
      echo event registered
      event emit "test event" runtime
      exit 1 # fail if emitting event didn't exit clean
      EOF
    '';

in
resholvePackage rec {
  # bashup.events doesn't version yet but it has two variants with
  # differing features/performance characteristics:
  # - branch master: a variant for bash 3.2+
  # - branch bash44: a variant for bash 4.4+
  pname = "bashup-events${variant}-unstable";
  # should be YYYY-MM-DD
  inherit version;
  inherit src;

  installPhase = ''
    install -Dt $out/bin bashup.events
  '';

  inherit doCheck;
  checkInputs = [ shellcheck bash ];

  # check based on https://github.com/bashup/events/blob/master/.dkrc
  checkPhase = ''
    SHELLCHECK_OPTS='-e SC2016,SC2145' ${shellcheck}/bin/shellcheck ./bashup.events
    ${bash}/bin/bash -n ./bashup.events
    ${bash}/bin/bash ./bashup.events
  '';

  solutions = {
    events = {
      inputs = [ ];
      interpreter = "none";
      scripts = [ "bin/bashup.events" ];
      inherit keep;
    } // lib.optionalAttrs (lib.isAttrs fake) { inherit fake; };
  };

  inherit doInstallCheck;
  installCheckInputs = [ bash ];
  installCheckPhase = installCheck "${bash}/bin/bash";

  meta = with lib; {
    inherit branch;
    description = "An event listener/callback API for creating extensible bash programs";
    homepage = "https://github.com/bashup/events";
    license = licenses.cc0;
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
