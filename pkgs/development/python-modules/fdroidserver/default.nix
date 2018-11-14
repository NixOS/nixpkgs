{ stdenv
, buildPythonPackage
, fetchFromGitLab
, libcloud
, pyyaml
, paramiko
, pyasn1
, pyasn1-modules
, pillow
, mwclient
, GitPython
, isPy3k
}:

buildPythonPackage rec {
  version = "2016-05-31";
  pname = "fdroidserver-git";
  disabled = ! isPy3k;

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = "401649e0365e6e365fc48ae8a3af94768af865f3";
    sha256 = "1mmi2ffpym1qw694yj938kc7b4xhq0blri7wkjaqddcyykjyr94d";
  };

  propagatedBuildInputs = [ libcloud pyyaml paramiko pyasn1 pyasn1-modules pillow mwclient GitPython ];

  meta = with stdenv.lib; {
    homepage = https://f-droid.org;
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3;
  };

}
