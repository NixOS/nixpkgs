#!/usr/bin/env nix-shell
#! nix-shell -i bash -p rsstail nix-prefetch

# NOTE: Before running this script, please make sure this list is up-to-date -
# meaning there are no new fonts they provide at https://github.com/ryanoasis/nerd-fonts/releases/
fonts=(
	"3270"
	Agave
	AnonymousPro
	Arimo
	AurulentSansMono
	BigBlueTerminal
	BitstreamVeraSansMono
	CascadiaCode
	CodeNewRoman
	Cousine
	DaddyTimeMono
	DejaVuSansMono
	DroidSansMono
	FantasqueSansMono
	FiraCode
	FiraMono
	Go-Mono
	Gohu
	Hack
	Hasklig
	HeavyData
	Hermit
	iA-Writer
	IBMPlexMono
	Inconsolata
	Iosevka
	JetBrainsMono
	Lekton
	LiberationMono
	Meslo
	Monofur
	Monoid
	Mononoki
	MPlus
	Noto
	OpenDyslexic
	Overpass
	ProFont
	ProggyClean
	RobotoMono
	ShareTechMono
	SourceCodePro
	SpaceMono
	Terminus
	Tinos
	Ubuntu
	VictorMono
)

releases_url="https://github.com/ryanoasis/nerd-fonts/releases.atom"

version="$(rsstail -1 -u "$releases_url" -H -l -r | sed -e '/^Title: /d' -e 's:.*/::' -e 's/^v//g' | sort -V | tail -1)"

echo Using version "$version"

dirname="$(dirname "$0")"
echo \""$version"\" > "$dirname/version.nix"

base_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}"

printf '{\n' > "$dirname/shas.nix"

for font in "${fonts[@]}"; do
	printf '\t"%s" = "%s";\n' "$font" "$(nix-prefetch-url "${base_url}/${font}.zip")" >> "$dirname/shas.nix"
done

printf '}\n' >> "$dirname/shas.nix"
