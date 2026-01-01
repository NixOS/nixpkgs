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

<<<<<<< HEAD
  meta = {
    description = "Flexible and fast xcodebuild formatter";
    homepage = "https://github.com/supermarin/xcpretty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Flexible and fast xcodebuild formatter";
    homepage = "https://github.com/supermarin/xcpretty";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      nicknovitski
    ];
  };
}
