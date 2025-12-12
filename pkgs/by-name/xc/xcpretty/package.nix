{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "xcpretty";
  gemdir = ./.;

  exes = [ "xcpretty" ];

  passthru = {
    updateScript = bundlerUpdateScript "xcpretty";
  };

  meta = {
    description = "Flexible and fast xcodebuild formatter";
    homepage = "https://github.com/supermarin/xcpretty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
  };
}
