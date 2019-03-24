{ pkgs, buildComposerEnv, php, noDev ? true }:

let
  langServerPkg = import ./php-packages.nix {
    composerEnv = buildComposerEnv;
    inherit (pkgs) fetchurl fetchgit fetchhg fetchsvn;
  };
in buildComposerEnv.buildPackage rec {
  inherit noDev;
  inherit (langServerPkg) packages devPackages;

  pname = "php-language-server";
  version = "5.4.6";

  src = ./.;

  executable = true;
  symlinkDependencies = false;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  # We remove the symlink created for the bin path because the php file provided
  # miss a shebang. So we'll just wrap it instead.
  postInstall = ''
    rm $out/bin
    mkdir -p $out/bin
    makeWrapper ${php}/bin/php $out/bin/${pname} \
      --add-flags "$out/share/php/${pname}-${version}/vendor/bin/${pname}.php"

    # Change permissions so we can write the stubs
    chmod u+w $out/share/php/${pname}-${version}/vendor/felixfbecker/language-server/

    # Generate the stubs file
    composer run-script --working-dir=$out/share/php/${pname}-${version}/vendor/felixfbecker/language-server parse-stubs

    # Remove the permissions we added
    chmod u-w -R $out/share/php/${pname}-${version}/vendor/felixfbecker/language-server/
  '';

  meta = with pkgs.lib; {
    description = "PHP Implementation of the VS Code Language Server Protocol";
    license = licenses.isc;
    homepage = "https://github.com/felixfbecker/php-language-server";
    maintainers = with maintainers; [ etu ];
  };
}
