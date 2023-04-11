{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phan";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "phan";
    repo = "phan";
    rev = finalAttrs.version;
    hash = "sha256-AoY0+2v9wXQQzrNLo3xnuq8djZg15epiV748/pUtBqM=";
  };

  php = php.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      ast
    ]));
  };

  vendorHash = "sha256-ARhcc7Cu8SHzy6dlj+iFjEuupnxdKX7XjLJ3nPNqzO4=";

  meta = with lib; {
    description = "Static analyzer for PHP";
    longDescription = ''
      Phan is a static analyzer for PHP. Phan prefers to avoid false-positives
      and attempts to prove incorrectness rather than correctness.
    '';
    license = licenses.mit;
    homepage = "https://github.com/phan/phan";
    maintainers = with maintainers; [ apeschar ] ++ teams.php.members;
  };
})
