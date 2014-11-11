{ stdenv, fetchgit, doxygen, boost, pkgconfig, python, pythonPackages, ndn-cxx, graphviz, libpcap, openssl }:
let
  version = "3651fd";
in
stdenv.mkDerivation {
  name = "nfd-0.2-${version}";
  src = fetchgit {
    url = "https://github.com/named-data/NFD.git";
    rev = "3651fd75f79c0f8cb2bf67193d4ef581cebaee8c";
    sha256 = "18lk6vpwpys8189jbjcrhhqhz6pmqxjimkfkx9fhszhgv8mcbgy5";
  };
  buildInputs = [ doxygen boost pkgconfig openssl python pythonPackages.sphinx ndn-cxx graphviz libpcap];
  preConfigure = ''
    patchShebangs ./waf
    ./waf configure \
      --boost-includes=${boost.dev}/include \
      --boost-libs=${boost.lib}/lib \
      --with-libpcap=${libpcap} \
      --sysconfdir=/etc/ndn \
      --prefix=$out
  '';
  buildPhase = ''
    ./waf
  '';
  installPhase = ''
    mkdir /etc/ndn
    cp $out/etc/ndn/ndn.conf.sample /etc/ndn/ndn.conf
    ./waf install
  '';
  meta = with stdenv.lib; {
    homepage = "http://named-data.net/doc/NFD/current/";
    description = "NFD is a network forwarder that implements the Named Data Networking (NDN) protocol.";
    longDescription = ''
      NDN Forwarding Daemon (NFD) is a network forwarder that implements and
      evolves together with the Named Data Networking (NDN) protocol.
      After the initial release, NFD will become a core component of the
      NDN Platform and will follow the same release cycle.

      The main design goal of NFD is to support diverse experimentation
      of NDN technology. The design emphasizes modularity and extensibility
      to allow easy experiments with new protocol features, algorithms,
      and applications. We have not fully optimized the code for performance.
      The intention is that performance optimizations are one type of experiments
      that developers can conduct by trying out different data structures and
      different algorithms; over time, better implementations may emerge within
      the same design framework. To facilitate such experimentation with the
      forwarder, the NFD team has also written a developer’s guide, which details
      the current implementation and provides tips for extending all aspects of NFD.

      NFD will keep evolving in three aspects: improvement of the modularity
      framework, keeping up with the NDN protocol spec, and addition of other
      new features. We hope to keep the modular framework stable and lean,
      allowing researchers to implement and experiment with various features,
      some of which may eventually work into the protocol spec.

      The design and development of NFD benefited from our earlier experience
      with CCNx software package. However, NFD is not in any part derived from
      CCNx codebase and does not maintain compatibility with CCNx.
    '';
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.sjmackenzie ];
  };
}
