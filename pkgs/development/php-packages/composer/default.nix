{ lib, callPackage, fetchFromGitHub, fetchpatch, php, unzip, _7zz, xz, git, curl, cacert, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-mhjho6rby5TBuv1sSpj/kx9LQ6RW70hXUTBGbhnwXdY=";

  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  pname = "composer";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-CKP7CYOuMKpuWdVveET2iLJPKJyCnv5YVjx4DE68UoE=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-24821.patch";
      url = "https://github.com/composer/composer/commit/77e3982918bc1d886843dc3d5e575e7e871b27b7.patch";
      hash = "sha256-Q7gkPLf59+p++DpfJZeOrAOiWePuGkdGYRaS/rK+Nv4=";
      excludes = [
        # Skipping test files, they are not included in the source tarball
        "tests/*"
      ];
    })
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-SG5RsKaP7zqJY2vjvULuNdf7w6tAGh7/dlxx2Pkfj2A=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
