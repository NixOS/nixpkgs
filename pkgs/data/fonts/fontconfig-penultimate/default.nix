{ stdenv, fetchzip }:

let version = "0.3.5"; in
fetchzip {
  name = "fontconfig-penultimate-${version}";

  url = "https://github.com/ttuegel/fontconfig-penultimate/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/etc/fonts/conf.d
    unzip -j $downloadedFile \*.conf -d $out/etc/fonts/conf.d
  '';

  sha256 = "1gfgl7qimp76q4z0nv55vv57yfs4kscdr329np701k0xnhncwvrk";

  meta = with stdenv.lib; {
    homepage = https://github.com/ttuegel/fontconfig-penultimate;
    description = "Sensible defaults for Fontconfig";
    license = licenses.asl20;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.all;
  };
}
