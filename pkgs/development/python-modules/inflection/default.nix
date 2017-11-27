{ lib, fetchurl, buildPythonPackage, pytest } :

buildPythonPackage rec {
   version = "0.3.1";
   name = "inflection-${version}";

   src = fetchurl {
     url= "mirror://pypi/i/inflection/${name}.tar.gz";
     sha256 = "1jhnxgnw8y3mbzjssixh6qkc7a3afc4fygajhqrqalnilyvpzshq";
   };

   propagatedBuildInputs = [ pytest ];

   meta = {
     homepage = https://github.com/jpvanhal/inflection;
     description = "A port of Ruby on Rails inflector to Python";
     maintainers = with lib.maintainers; [ NikolaMandic ilya-kolpakov ];
     license = lib.licenses.mit;
   };
}

