source $stdenv/setup

mkdir -p $out/xml/dtd/docbook-ebnf
cd $out/xml/dtd/docbook-ebnf
cp -p $dtd dbebnf.dtd
cp -p $catalog $(baseHash $catalog)
