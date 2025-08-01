{ callPackage, fetchFromGitHub }:

callPackage ./generic.nix {
  variant = "3.2";
  version = "2019-07-27";
  branch = "master";
  src = fetchFromGitHub {
    owner = "bashup";
    repo = "events";
    rev = "83744c21bf720afb8325343674c62ab46a8f3d94";
    hash = "sha256-0VDjd+1T1JBmSDGovWOOecUZmNztlwG32UcstfdigbI=";
  };
  fake = {
    # Note: __ev.encode is actually defined, but it happens in a
    # quoted arg to eval, which resholve currently doesn't (and may
    # never) parse into. See abathur/resholve/issues/2.
    function = [ "__ev.encode" ];
  };
  keep = {
    # allow vars in eval
    eval = [
      "e"
      "f"
      "q"
      "r"
    ];
    # allow vars executed as commands
    "$f" = true;
    "$n" = true;
  };
}
