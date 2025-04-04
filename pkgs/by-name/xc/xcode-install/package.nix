{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "xcode-install";
  gemdir = ./.;
  exes = [ "xcversion" ];

  passthru.updateScript = bundlerUpdateScript "xcode-install";

  meta = with lib; {
    description = "Install and update your Xcodes automatically";
    homepage = "https://github.com/xcpretty/xcode-install";
    platforms = platforms.unix;
    maintainers = with maintainers; [ q3k ];
    license = with licenses; [ mit ];
  };
}
