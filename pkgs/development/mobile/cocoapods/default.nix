{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  inherit ruby;
  pname = "cocoapods";
  gemdir = ./.;

  meta = with lib; {
    description     = "CocoaPods manages dependencies for your Xcode projects.";
    homepage        = https://github.com/CocoaPods/CocoaPods;
    license         = licenses.mit;
    maintainers     = with maintainers; [
      peterromfeldhk
    ];
  };
}
