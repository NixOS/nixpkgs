{ stdenv, fetchFromGitHub, autoreconfHook, python }:

let version = "2.0.22"; in
stdenv.mkDerivation {
  name = "libevent-${version}";

  src = fetchFromGitHub {
    owner = "libevent";
    repo = "libevent";
    rev = "release-${version}-stable";
    sha256 = "1x2437af9j870i7l37dav1i2g9z93lbz406kyimx4nq5qcx5463p";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ python ];

  patchPhase = ''
    patchShebangs event_rpcgen.py
  '';

  meta = with stdenv.lib; {
    description = "Event notification library";

    longDescription =
      '' The libevent API provides a mechanism to execute a callback function
         when a specific event occurs on a file descriptor or after a timeout
         has been reached.  Furthermore, libevent also support callbacks due
         to signals or regular timeouts.

         libevent is meant to replace the event loop found in event driven
         network servers.  An application just needs to call event_dispatch()
         and then add or remove events dynamically without having to change
         the event loop.
      '';

    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
