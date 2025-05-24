{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp rec {
  pname = "xcode-install";
  gemdir = ./.;
  exes = [ "xcversion" ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = with lib; {
    description = "Install and update your Xcodes automatically";
    homepage = "https://github.com/xcpretty/xcode-install";
    platforms = platforms.unix;
    maintainers = with maintainers; [ q3k ];
    license = with licenses; [ mit ];
  };
}
