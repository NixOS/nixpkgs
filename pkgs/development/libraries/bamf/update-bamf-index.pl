#!@perl@/bin/perl

# Taken from ubuntu packaging
# See: https://git.launchpad.net/bamf/tree/debian/bamfdaemon.postinst
#
# Take note that this certainly isn't a robust solution.
#
# However the elementary project will eventually remove
# its depdenence on libbamf and libwnck and migrate to
# becoming compatable with Wayland.
#
# See:
#
# - https://github.com/elementary/gala/issues/68
# - https://github.com/elementary/gala/issues/70
# - https://github.com/elementary/gala/issues/297

use File::Find;
my $dir_name;

sub strip_exec
{
    my $f = $_;
    return unless $f =~ /\.desktop$/;
    return unless ("$File::Find::dir" eq "$dir_name");
    my @lines;
    open F, $f;
    @lines = <F>;
    close F;
    my $in_desktop_entry = 0;
    my $exec = "";
    my $class = "";
    my $no_display = "false";
    my $only_show_in = "";

    foreach (@lines)
    {
        if (/^\[\s*(.+)\s*\]/)
        {
            $was_in_desktop = $in_desktop_entry;
            $in_desktop_entry = ($1 eq "Desktop Entry");

            if ($was_in_desktop and !$in_desktop_entry)
            {
                last;
            }
        }

        if ($in_desktop_entry)
        {
            if (/^Exec=(.+)$/)
            {
                $exec = $1;
                $exec =~ s/^\s+|\s+$//g;
            }

            if (/^NoDisplay=(.+)$/)
            {
                $no_display = $1;
                $no_display =~ s/^\s+|\s+$//g;
            }

            if (/^OnlyShowIn=(.+)$/)
            {
                $only_show_in = $1;
                $only_show_in =~ s/^\s+|\s+$//g;
            }

            if (/^StartupWMClass=(.+)$/)
            {
                $class = $1;
                $class =~ s/^\s+|\s+$//g;
            }
        }
    }

    if ($exec ne "")
    {
        print "$f\t$exec\t$class\t$only_show_in\t$no_display\n";
    }
};

$dir_name = $ARGV[-1];
$dir_name = $1 if($dir_name=~/(.*)\/$/);
find(\&strip_exec, $dir_name);
