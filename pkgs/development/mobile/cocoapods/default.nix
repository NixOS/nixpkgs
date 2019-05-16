{ lib, bundlerApp, ruby
, beta ? false }:

bundlerApp rec {
  inherit ruby;
  pname = "cocoapods";
  gemfile = if beta then ./Gemfile-beta else ./Gemfile;
  lockfile = if beta then ./Gemfile-beta.lock else ./Gemfile.lock;
  gemset = if beta then ./gemset-beta.nix else ./gemset.nix;
  exes = [ "pod" ];

  meta = with lib; {
    description     = "CocoaPods manages dependencies for your Xcode projects.";
    homepage        = https://github.com/CocoaPods/CocoaPods;
    license         = licenses.mit;
    platforms       = platforms.darwin;
    maintainers     = with maintainers; [
      peterromfeldhk
      lilyball
    ];
  };
}
