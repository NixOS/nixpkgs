/* An environment for development that bundles ruby, bundler and bundix
   together. This avoids version conflicts where each is using a different
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
