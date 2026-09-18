# This is a shim around whatever real rbconfig.rb is in the LOAD_PATH,
# so that RbConfig::CONFIG["ridir"] can be overridden to point to the
# custom location of the ri docs, without the main derivation having
# those docs in its closure.

MY_PATH = File.realpath(__FILE__)

candidates = $LOAD_PATH.map { |dir| File.join(dir, "rbconfig.rb") }

# First, drop everything _before_ this file in the LOAD_PATH, just on
# the off-chance somebody is composing shims like this for some reason.
candidates.drop_while { |c| !File.exist?(c) || File.realpath(c) != MY_PATH }

# Now, the wrapped rbconfig.rb is the next rbconfig.rb in the LOAD_PATH
# that isn't this same file. (Yes, duplicate LOAD_PATH entries are a
# thing we have to deal with.)
next_rbconfig = candidates.find { |c|
  File.exist?(c) && File.realpath(c) != MY_PATH
}

# Load the wrapped rbconfig.rb
require next_rbconfig

# Now we have RbConfig, and can modify it for our own ends.
RbConfig::CONFIG["ridir"] = File.expand_path("../../../share/ri", __dir__)
