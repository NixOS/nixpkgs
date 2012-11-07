let
  pkgs = import <nixpkgs> {};
in
rec {
  myfirstapp = import ./myfirstapp {
    inherit (pkgs) androidenv;
  };
  
  emulate_myfirstapp = import ./emulate-myfirstapp {
    inherit (pkgs) androidenv;
    inherit myfirstapp;
  };
}
