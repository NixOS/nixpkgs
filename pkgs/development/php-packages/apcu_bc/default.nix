{ buildPecl, lib, pcre2, php, fetchFromGitHub }:

buildPecl rec {
  pname = "apcu_bc";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu-bc";
    rev = version;
    sha256 = "sha256-CDhNDk78D15MtljbtyYj8euPnCruLZnc2NEHqXDX8HY=";
  };

  peclDeps = [ php.extensions.apcu ];

  buildInputs = [ pcre2 ];

  postInstall = ''
    mv $out/lib/php/extensions/apc.so $out/lib/php/extensions/apcu_bc.so
  '';

  meta = with lib; {
    description = "APCu Backwards Compatibility Module";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/apcu_bc";
    maintainers = teams.php.members;
    broken = versionAtLeast php.version "8";
  };
}
