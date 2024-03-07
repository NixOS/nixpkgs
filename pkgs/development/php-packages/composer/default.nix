{ lib
, callPackage
, fetchFromGitHub
, php
, unzip
, _7zz
, xz
, git
, curl
, cacert
, makeBinaryWrapper
}:

php.buildComposerProject (finalAttrs: {
  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-H/0L4/J+I3sa5H+ejyn5asf1CgvZ7vT4jNvpTdBL//A=";

  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  pname = "composer";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-OThWqY3m/pIas4qvR/kiYgc/2QrAbnsYEOxpHxKhDfM=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-NJa6nu60HQeBJr7dd79ATptjcekgY35Jq9V40SrN9Ds";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
