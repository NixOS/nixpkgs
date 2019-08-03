{ stdenv, buildPythonPackage, fetchPypi, isPy3k, which
, django, django_tagging, whisper, pycairo, cairocffi, ldap, memcached, pytz, urllib3, scandir
}:
if django.version != "1.8.19"
|| django_tagging.version != "0.4.3"
then throw "graphite-web should be build with django_1_8 and django_tagging_0_4_3"
else buildPythonPackage rec {
  pname = "graphite-web";
  version = "1.1.5";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d43945d190f2b3a6d18daa6ace9a1bd3695e93dc593f50cd72c2af420883b99d";
  };

  propagatedBuildInputs = [
    django django_tagging whisper pycairo cairocffi
    ldap memcached pytz urllib3 scandir
  ];

  postInstall = ''
    wrapProgram $out/bin/run-graphite-devel-server.py \
      --prefix PATH : ${which}/bin
  '';

  preConfigure = ''
    # graphite is configured by storing a local_settings.py file inside the
    # graphite python package. Since that package is stored in the immutable
    # Nix store we can't modify it. So how do we configure graphite?
    #
    # First of all we rename "graphite.local_settings" to
    # "graphite_local_settings" so that the settings are not looked up in the
    # graphite package anymore. Secondly we place a directory containing a
    # graphite_local_settings.py on the PYTHONPATH in the graphite module
    # <nixpkgs/nixos/modules/services/monitoring/graphite.nix>.
    substituteInPlace webapp/graphite/settings.py \
      --replace "graphite.local_settings" " graphite_local_settings"

    substituteInPlace webapp/graphite/settings.py \
      --replace "join(WEBAPP_DIR, 'content')" "join('$out', 'webapp', 'content')"
  '';

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Enterprise scalable realtime graphing";
    maintainers = with maintainers; [ rickynils offline basvandijk ];
    license = licenses.asl20;
  };
}
