{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  ruby_3_4,
  withMongo ? false,
  withRchardet ? false,
}:

let
  gemdir =
    if withMongo && withRchardet then
      ./gems
    else if withMongo then
      ./gems
    else if withRchardet then
      ./gems
    else
      ./gems;

  gemfile =
    if withMongo then
      gemdir + "/Gemfile.mongo"
    else if withRchardet then
      gemdir + "/Gemfile.rchardet"
    else
      gemdir + "/Gemfile";

  lockfile =
    if withMongo then
      gemdir + "/Gemfile.mongo.lock"
    else if withRchardet then
      gemdir + "/Gemfile.rchardet.lock"
    else
      gemdir + "/Gemfile.lock";

  gemset =
    if withMongo then
      gemdir + "/gemset.mongo.nix"
    else if withRchardet then
      gemdir + "/gemset.rchardet.nix"
    else
      gemdir + "/gemset.nix";

  gems = bundlerEnv {
    name = "whatweb-env";
    inherit ruby_3_4;
    inherit gemdir;
    inherit gemfile lockfile gemset;
  };
in
stdenv.mkDerivation rec {
  pname = "whatweb";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "urbanadventurer";
    repo = "whatweb";
    rev = "v${version}";
    sha256 = "sha256-EFQ4RHI1+kmlz/Bm+9KXbmY0iEBJnKfdQL5YGDWCfJQ=";
  };

  prePatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local" "$out" \
      --replace "/usr" "$out" \
      --replace "bundle install" "echo 'Skipping bundle install in nix build'"
  '';

  buildInputs = [ gems ];

  installPhase = ''
    runHook preInstall

    raw=$out/share/whatweb/whatweb
    rm $out/bin/whatweb
    cat << EOF >> $out/bin/whatweb
    #!/bin/sh -e
    export GEM_PATH="${gems}/lib/ruby/gems/3.3.0"
    export RUBYOPT="-W0"
    exec ${ruby_3_4}/bin/ruby "$raw" "\$@"
    EOF
    chmod +x $out/bin/whatweb

    runHook postInstall
  '';

  passthru = {
    withMongo = withMongo;
    withRchardet = withRchardet;
  };

  meta = with lib; {
    description = "Next generation web scanner";
    longDescription = ''
      WhatWeb is a website fingerprinting tool that identifies web technologies such as CMSs, blogging platforms,
      analytics packages, JavaScript libraries, web servers, and embedded devices. With over 1800 plugins, it detects software
      versions, email addresses, account IDs, web framework modules, SQL errors, and more. WhatWeb offers adjustable scan
      modes, balancing speed and thoroughness, making it suitable for both quick reconnaissance and detailed penetration
      testing. Its plugins use multiple detection methods to reliably identify technologies, even when sites attempt to
      obscure their software.
    ''
    + lib.optionalString withMongo ''

      This build includes MongoDB support and character set detection capabilities, which may impact performance.
    ''
    + lib.optionalString (withRchardet && !withMongo) ''

      This build includes character set detection capabilities, which may impact performance.
    '';
    mainProgram = "whatweb";
    homepage = "https://github.com/urbanadventurer/whatweb";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
