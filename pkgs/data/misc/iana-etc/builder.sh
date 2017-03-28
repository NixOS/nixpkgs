source $stdenv/setup

# Curl flags :
# progress-bar is lighter on the screen
# retry 3 times
# fail silently (no output at all) on server errors ; an error code is still returned
# use only TLSv1.0, TLSv1.1 or TLSv1.2
# use the collections of trusted CAs from ${cacert}
# write output to a local file named like the remote file we get
# TODO: for security it would be possible to pin IANA certificate with --pinnedpubkey
curl="curl \
  --progress-bar \
  --retry 3 \
  --fail \
  --tlsv1 \
  --cacert $cacert/etc/ssl/certs/ca-bundle.crt \
  -O"


# Fetch protocols-numbers.xml over HTTPS
$curl "https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml"
protoxml="protocol-numbers.xml"

# Fetch service-names-port-numbers.xml over HTTPS
$curl "https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml"
svcxml="service-names-port-numbers.xml"


# Make sure protocol-numbers.xml is readable and is the file we expect
if [ ! -r $protoxml ] \
  || [ "$(head -n 1 $protoxml)" != "<?xml version='1.0' encoding='UTF-8'?>" ] \
  || [ "$(awk -F'[<>]' '/registry xmlns/{print $2; exit}' $protoxml)" != 'registry xmlns="http://www.iana.org/assignments" id="protocol-numbers"' ]
then
  echo 'ERROR: protocol-numbers.xml does not match the expected structure'
  exit 1
fi

# Same checks on service-names-port-numbers.xml
if [ ! -r $svcxml ] \
  || [ "$(head -n 1 $svcxml)" != "<?xml version='1.0' encoding='UTF-8'?>" ] \
  || [ "$(awk -F'[<>]' '/registry xmlns/{print $2; exit}' $svcxml)" != 'registry xmlns="http://www.iana.org/assignments" id="service-names-port-numbers"' ]
then
  echo 'ERROR: service-names-port-numbers.xml does not match the expected structure'
  exit 1
fi


# Create final directory in Nix store
mkdir -pv $out/etc

# Process /etc/protocols from IANA protocol-numbers.xml and install it
gawk '
BEGIN {
  print "# See also protocols(5) and IANA official page :"
  print "# https://www.iana.org/assignments/protocol-numbers \n#"
  FS="[<>]"
}
{
  if (/<updated/) { print "# Last updated: " $3 "\n" ; next }
  if (/<record/) { v=n=0 }
  if (/<value/) v=$3
  if (/<name/ && !($3~/ /)) n=$3
  if (/<\/record/ && (v || n=="HOPOPT") && n) printf "%-16s %3i %s\n", tolower(n),v,n
  if (/<people/) exit
}
' $protoxml > $out/etc/protocols

# Process /etc/services from IANA service-names-port-numbers.xml and install it
gawk '
BEGIN {
  print "# See also services(5) and IANA official page :"
  print "# https://www.iana.org/assignments/service-names-port-numbers \n#"
  FS="[<>]"
}
{
  if (/<updated/) { print "# Last updated: " $3 "\n" ; next }
  if (/<record/) { n=u=p=c=0 }
  if (/<name/ && !/\(/) n=$3
  if (/<number/) u=$3
  if (/<protocol/) p=$3
  if (/Unassigned/ || /Reserved/ || /historic/) c=1
  if (/<\/record/ && n && u && p && !c) printf "%-16s %5i/%s\n", n,u,p
  if (/<people/) exit
}
' $svcxml > $out/etc/services


# Some cleanup before leaving
rm *.xml
