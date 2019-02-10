source "$stdenv/setup"

mkdir -p $out/share/GeoIP
cd $out/share/GeoIP

# Iterate over all environment variable names beginning with "src":
for var in "${!src@}"; do
	# Store the value of the variable with name $var in $src:
	eval src="\$$var"

	# Copy $src to current directory, removing Nix hash from the filename:
	dest="${src##*/}"
	dest="${dest#*-}"
	cp "$src" "$dest"
done

gzip -dv *.gz

ln -s GeoLiteCity.dat GeoIPCity.dat
ln -s GeoLiteCityv6.dat GeoIPCityv6.dat
