{ stdenv, buildPythonPackage, fetchPypi, isPy3k, boto, crcmod, psutil }:

buildPythonPackage rec {
  pname = "buttersink";
  version = "0.6.8";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04gc63kfcqkw4qba5rijqk01xiphf04yk7hky9180ii64v2ip0j3";
  };

  propagatedBuildInputs = [ boto crcmod psutil ];

  meta = with stdenv.lib; {
    description = "Synchronise btrfs snapshots";
    longDescription = ''
      ButterSink is like rsync, but for btrfs subvolumes instead of files,
      which makes it much more efficient for things like archiving backup
      snapshots. It is built on top of btrfs send and receive capabilities.
      Sources and destinations can be local btrfs file systems, remote btrfs
      file systems over SSH, or S3 buckets.
    '';
    homepage = https://github.com/AmesCornish/buttersink/wiki;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
