{ lib, buildRubyGem, ruby, installShellFiles }:

# Cannot use bundleEnv because bundleEnv create stub with
# BUNDLE_FROZEN='1' environment variable set, which broke everything
# that rely on Bundler that runs under Tmuxinator.

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tmuxinator";
  version = "3.3.3";
  source.sha256 = "sha256-kT0S5I+x5qYKqMwSOQl1je1zfOPOj2KT8YvJc7jFp5A=";

  erubi = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "erubi";
    version = "1.13.0";
    source.sha256 = "fca61b47daefd865d0fb50d168634f27ad40181867445badf6427c459c33cd62";
  };

  thor = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "thor";
    version = "1.3.2";
    source.sha256 = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
  };

  xdg = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "xdg";
    version = "2.2.5";
    source.sha256 = "04xr4cavnzxlk926pkji7b5yiqy4qsd3gdvv8mg6jliq6sczg9gk";
  };

  propagatedBuildInputs = [ erubi thor xdg ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion $GEM_HOME/gems/${gemName}-${version}/completion/tmuxinator.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "Manage complex tmux sessions easily";
    homepage    = "https://github.com/tmuxinator/tmuxinator";
    license     = licenses.mit;
    maintainers = with maintainers; [ auntie ericsagnes ];
    platforms   = platforms.unix;
    mainProgram = "tmuxinator";
  };
}
