{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  perl,
  autoreconfHook,
}:

let
  # when upgrade znapzend, check versions of Perl libs here: https://github.com/oetiker/znapzend/blob/master/cpanfile
  # pinned versions are listed at https://github.com/oetiker/znapzend/blob/v0.23.1/thirdparty/cpanfile-5.38.snapshot

  MojoLogClearable = perl.pkgs.buildPerlModule rec {
    pname = "Mojo-Log-Clearable";
    version = "1.001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DB/DBOOK/Mojo-Log-Clearable-${version}.tar.gz";
      hash = "sha256-guBqKdWemc4mC/xp77Wd7qeV2iRqY4wrQ5NRsHtsCnI=";
    };
    buildInputs = with perl.pkgs; [ ModuleBuildTiny ];
    propagatedBuildInputs = with perl.pkgs; [
      Mojolicious
      RoleTiny
      ClassMethodModifiers
    ];
  };

  perl' = perl.withPackages (
    p: with p; [
      ClassMethodModifiers
      ExtUtilsConfig
      ExtUtilsHelpers
      ExtUtilsInstallPaths
      ModuleBuildTiny
      MojoLogClearable
      Mojolicious
      RoleTiny
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "znapzend";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "oetiker";
    repo = "znapzend";
    # Sometimes there's a branch with the same name as the tag,
    # confusing fetchFromGitHub. Working around this by prefixing
    # with `refs/tags/`.
    tag = "v${finalAttrs.version}";
    hash = "sha256-UvaYzzV+5mZAAwSSMzq4fjCu/mzjeSyQdwQRTZGNktM=";
  };

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [ perl' ];
  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    sed -i 's/^SUBDIRS =.*$/SUBDIRS = lib/' Makefile.am
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/znapzend --version
  '';

  meta = {
    description = "High performance open source ZFS backup with mbuffer and ssh support";
    homepage = "https://www.znapzend.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      otwieracz
      ma27
    ];
    platforms = lib.platforms.all;
  };
})
