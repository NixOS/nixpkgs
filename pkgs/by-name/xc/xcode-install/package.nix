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

<<<<<<< HEAD
  meta = {
    description = "Install and update your Xcodes automatically";
    homepage = "https://github.com/xcpretty/xcode-install";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ q3k ];
    license = with lib.licenses; [ mit ];
=======
  meta = with lib; {
    description = "Install and update your Xcodes automatically";
    homepage = "https://github.com/xcpretty/xcode-install";
    platforms = platforms.unix;
    maintainers = with maintainers; [ q3k ];
    license = with licenses; [ mit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
