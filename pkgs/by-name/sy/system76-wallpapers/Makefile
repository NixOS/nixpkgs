BACKGROUNDS=$(wildcard backgrounds/*)
SCALED=$(sort $(patsubst backgrounds/%, scaled/%, $(BACKGROUNDS)))

prefix ?= /usr
datarootdir = $(prefix)/share
datadir = $(datarootdir)

.PHONY: all clean install uninstall

all: $(SCALED) scaled/info.xml

clean:
	rm -rf build scaled

install: all
	for file in $(SCALED); do \
		install -D -m 0644 "$$file" "$(DESTDIR)$(datadir)/backgrounds/system76/$$(basename "$$file")"; \
	done
	install -D -m 0644 "scaled/info.xml" "$(DESTDIR)$(datadir)/gnome-background-properties/system76-wallpapers.xml"

uninstall:
	for file in $(SCALED); do \
		rm -f "$(DESTDIR)$(datadir)/backgrounds/system76/$$(basename "$$file")"; \
	done
	rmdir --ignore-fail-on-non-empty "$(DESTDIR)$(datadir)/backgrounds/system76/"
	rm -f "$(DESTDIR)$(datadir)/gnome-background-properties/system76-wallpapers.xml"
	rmdir --ignore-fail-on-non-empty "$(DESTDIR)$(datadir)/gnome-background-properties/"

scaled/%: backgrounds/%
	@mkdir -p build scaled
	magick "$<" -resize "3840x2160^" "build/$*"
	mv "build/$*" "$@"

scaled/info.xml: $(SCALED)
	@mkdir -p build scaled
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "build/info.xml"
	echo "<!DOCTYPE wallpapers SYSTEM \"gnome-wp-list.dtd\">" >> "build/info.xml"
	echo "<wallpapers>" >> "build/info.xml"
	for file in $(SCALED); do \
		filename="$$(basename "$$file")"; \
		name="$${filename%.*}"; \
		echo "    <wallpaper>" >> "build/info.xml"; \
		echo "        <name>$$name</name>" >> "build/info.xml"; \
		echo "        <filename>/usr/share/backgrounds/system76/$$(basename "$$file")</filename>" >> "build/info.xml"; \
		echo "        <options>zoom</options>" >> "build/info.xml"; \
		echo "        <pcolor>#000000</pcolor>" >> "build/info.xml"; \
		echo "        <scolor>#000000</scolor>" >> "build/info.xml"; \
		echo "        <shade_type>solid</shade_type>" >> "build/info.xml"; \
		echo "    </wallpaper>" >> "build/info.xml"; \
	done
	echo "</wallpapers>" >> "build/info.xml"
	mv "build/info.xml" "$@"
