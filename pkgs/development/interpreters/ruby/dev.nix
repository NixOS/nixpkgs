/* An environment for development that bundles ruby, bundler and bundix
<<<<<<< HEAD
   together. This avoids version conflicts where each is using a different
=======
   together. This avoids version conflicts where each is using a diferent
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
   version of each-other.
*/
{ buildEnv, ruby, bundler, bundix }:
let
  bundler_ = bundler.override {
    ruby = ruby;
  };
  bundix_ = bundix.override {
    bundler = bundler_;
  };
in
buildEnv {
  name = "${ruby.rubyEngine}-dev-${ruby.version}";
  paths = [
    bundix_
    bundler_
    ruby
  ];
  pathsToLink = [ "/bin" ];
  ignoreCollisions = true;
}
