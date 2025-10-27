{
  lib,
  buildPythonPackage,
  replaceVars,
  fetchFromGitHub,
  setuptools,
  setuptools-git-versioning,
  logistro,
  simplejson,
  ungoogled-chromium,
  pytestCheckHook,
  pytest-asyncio,
  async-timeout,
  numpy,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "choreographer";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "choreographer";
    tag = "v${version}";
    hash = "sha256-bhKDWTO8uHt/igxAgnOc2JU6Z9sMrZoGMLcJaEdbXF0=";
  };

  # TODO: This seems rather fragile and it would be good to be able to upstream some build options to avoid having to do this
  patches = [
    (replaceVars ./nixpkgs-chromium.patch {
      # ungoogled-chromium works just as well
      chromium_bin = lib.getExe ungoogled-chromium;
    })
    ./bypass-libs-ok.patch
  ];

  build-system = [
    setuptools
    setuptools-git-versioning
  ];
  dependencies = [
    logistro
    simplejson
  ];
  nativeCheckInputs = [
    pytestCheckHook

    # Undeclared but definitely needed
    pytest-asyncio
    async-timeout
    numpy
  ];

  pytestFlags = [ "--log-level=DEBUG" ];

  # This may need a VM Test
  /*
    DEBUG    root:_which.py:64 Looking for browser, skipping local? False
    DEBUG    root:_which.py:76 Looking for at local chrome download path: /nix/store/sllkqs1dvi52nbps2jfkksdyl28wf88l-ungoogled-chromium-141.0.7390.122/bin/chromium
    DEBUG    root:_which.py:78 Returning local chrome.
    INFO     choreographer.browsers.chromium:chromium.py:171 Found chromium path: /nix/store/sllkqs1dvi52nbps2jfkksdyl28wf88l-ungoogled-chromium-141.0.7390.122/bin/chrom>
    INFO     choreographer.browser_async:browser_async.py:118 Opening browser.
    DEBUG    choreographer.browser_async:browser_async.py:145 Trying to open browser.
    INFO     choreographer.utils._tmpfile:_tmpfile.py:80 Temp directory created: /build/tmpze11_1kk.
    DEBUG    choreographer.browsers.chromium:chromium.py:118 (nixpkgs) bypassing broken _libs_ok check
    INFO     choreographer.browsers.chromium:chromium.py:186 Temporary directory at: /build/tmpze11_1kk
    DEBUG    choreographer.browsers.chromium:chromium.py:274 Returning cli: ['/nix/store/cfapjd2rvqrpry4grb0kljnp8bvnvfxz-python3-3.13.8/bin/python3.13', '/build/source/>
    DEBUG    choreographer.browsers.chromium:chromium.py:210 Returning args: {'close_fds': True, 'stdin': 19, 'stdout': 18}
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:183 Created new target 0.
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:55 New session:
    DEBUG    choreographer.browser_async:browser_async.py:153 Starting watchdog
    DEBUG    choreographer.browser_async:browser_async.py:155 Opening channel.
    DEBUG    choreographer.browser_async:browser_async.py:157 Running read loop
    DEBUG    choreographer.browser_async:browser_async.py:159 Populating Targets
    DEBUG    choreographer.browser_async:browser_async.py:286 In watchdog
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:90 Cmd 'Target.getTargets', param keys '', sessionId ''
    DEBUG    choreographer._brokers._async:_async.py:246 Broker writing Target.getTargets with key ('', 0)
    DEBUG    choreographer._brokers._async:_async.py:255 Created future: ('', 0) <Future pending>
    DEBUG    choreographer.channels._wire:_wire.py:57 Serialized: {"id": 0, "meth...et.getTargets"}, size: 40
    DEBUG    choreographer.channels.pipe:pipe.py:95 Writing message b'{"id": 0, "meth'...b't.getTargets"}\x00', size: 41.
    DEBUG    choreographer.channels.pipe:pipe.py:102 ***Wrote 41/41***
    DEBUG    choreographer.channels.pipe:pipe.py:152 First read in loop: b''...b''. size: 0.
    DEBUG    choreographer.channels.pipe:pipe.py:173 OSError
    DEBUG    choreographer.channels.pipe:pipe.py:179 Total loops: 1, Final size: 0.
    DEBUG    browser_proc::239 wrapper CLI: ['/nix/store/sllkqs1dvi52nbps2jfkksdyl28wf88l-ungoogled-chromium-141.0.7390.122/bin/chromium', '--disable-gpu', '--no-sandbox>
    DEBUG    browser_proc::239 [ERROR:dbus/bus.cc:408] Failed to connect to the bus: Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
    DEBUG    browser_proc::239 [ERROR:ui/ozone/platform/x11/ozone_platform_x11.cc:249] Missing X server or $DISPLAY
    DEBUG    browser_proc::239 [ERROR:ui/aura/env.cc:257] The platform failed to initialize.  Exiting.
    DEBUG    browser_proc::239 Fontconfig error: Cannot load default config file: No such file: (null)
    DEBUG    choreographer.channels.pipe:pipe.py:152 First read in loop: b'{bye}\n'...b'{bye}\n'. size: 6.
    DEBUG    choreographer.channels.pipe:pipe.py:159 Received b'{bye}\n'. is bye?
    DEBUG    choreographer.channels.pipe:pipe.py:173 OSError
    DEBUG    choreographer.channels.pipe:pipe.py:179 Total loops: 1, Final size: 6.
    DEBUG    choreographer._brokers._async:_async.py:124 Error in readloop. Will post a close() task.
    DEBUG    choreographer._brokers._async:_async.py:129 PipeClosedError caught
    INFO     choreographer.browser_async:browser_async.py:243 Closing browser.
    DEBUG    choreographer.browser_async:browser_async.py:245 Cancelling watchdog.
    DEBUG    choreographer.browser_async:browser_async.py:250 Starting browser close methods.
    DEBUG    choreographer.browser_async:browser_async.py:215 Trying Browser.close
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:90 Cmd 'Browser.close', param keys '', sessionId ''
    DEBUG    choreographer._brokers._async:_async.py:246 Broker writing Browser.close with key ('', 1)
    DEBUG    choreographer._brokers._async:_async.py:255 Created future: ('', 1) <Future pending>
    DEBUG    choreographer.browser_async:browser_async.py:308 Watchdog full shutdown (in finally:)
    ESCOD
    DEBUG    root:_which.py:64 Looking for browser, skipping local? False
    DEBUG    root:_which.py:76 Looking for at local chrome download path: /nix/store/sllkqs1dvi52nbps2jfkksdyl28wf88l-ungoogled-chromium-141.0.7390.122/bin/chromium
    DEBUG    root:_which.py:78 Returning local chrome.
    INFO     choreographer.browsers.chromium:chromium.py:171 Found chromium path: /nix/store/sllkqs1dvi52nbps2jfkksdyl28wf88l-ungoogled-chromium-141.0.7390.122/bin/chrom>
    INFO     choreographer.browser_async:browser_async.py:118 Opening browser.
    DEBUG    choreographer.browser_async:browser_async.py:145 Trying to open browser.
    INFO     choreographer.utils._tmpfile:_tmpfile.py:80 Temp directory created: /build/tmpze11_1kk.
    DEBUG    choreographer.browsers.chromium:chromium.py:118 (nixpkgs) bypassing broken _libs_ok check
    INFO     choreographer.browsers.chromium:chromium.py:186 Temporary directory at: /build/tmpze11_1kk
    DEBUG    choreographer.browsers.chromium:chromium.py:274 Returning cli: ['/nix/store/cfapjd2rvqrpry4grb0kljnp8bvnvfxz-python3-3.13.8/bin/python3.13', '/build/source/>
    DEBUG    choreographer.browsers.chromium:chromium.py:210 Returning args: {'close_fds': True, 'stdin': 19, 'stdout': 18}
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:183 Created new target 0.
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:55 New session:
    DEBUG    choreographer.browser_async:browser_async.py:153 Starting watchdog
    DEBUG    choreographer.browser_async:browser_async.py:155 Opening channel.
    DEBUG    choreographer.browser_async:browser_async.py:157 Running read loop
    DEBUG    choreographer.browser_async:browser_async.py:159 Populating Targets
    DEBUG    choreographer.browser_async:browser_async.py:286 In watchdog
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:90 Cmd 'Target.getTargets', param keys '', sessionId ''
    DEBUG    choreographer._brokers._async:_async.py:246 Broker writing Target.getTargets with key ('', 0)
    DEBUG    choreographer._brokers._async:_async.py:255 Created future: ('', 0) <Future pending>
    DEBUG    choreographer.channels._wire:_wire.py:57 Serialized: {"id": 0, "meth...et.getTargets"}, size: 40
    DEBUG    choreographer.channels.pipe:pipe.py:95 Writing message b'{"id": 0, "meth'...b't.getTargets"}\x00', size: 41.
    DEBUG    choreographer.channels.pipe:pipe.py:102 ***Wrote 41/41***
    DEBUG    choreographer.channels.pipe:pipe.py:152 First read in loop: b''...b''. size: 0.
    DEBUG    choreographer.channels.pipe:pipe.py:173 OSError
    DEBUG    choreographer.channels.pipe:pipe.py:179 Total loops: 1, Final size: 0.
    DEBUG    browser_proc::239 wrapper CLI: ['/nix/store/sllkqs1dvi52nbps2jfkksdyl28wf88l-ungoogled-chromium-141.0.7390.122/bin/chromium', '--disable-gpu', '--no-sandbox>
    DEBUG    browser_proc::239 [ERROR:dbus/bus.cc:408] Failed to connect to the bus: Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
    DEBUG    browser_proc::239 [ERROR:ui/ozone/platform/x11/ozone_platform_x11.cc:249] Missing X server or $DISPLAY
    DEBUG    browser_proc::239 [ERROR:ui/aura/env.cc:257] The platform failed to initialize.  Exiting.
    DEBUG    browser_proc::239 Fontconfig error: Cannot load default config file: No such file: (null)
    DEBUG    choreographer.channels.pipe:pipe.py:152 First read in loop: b'{bye}\n'...b'{bye}\n'. size: 6.
    DEBUG    choreographer.channels.pipe:pipe.py:159 Received b'{bye}\n'. is bye?
    DEBUG    choreographer.channels.pipe:pipe.py:173 OSError
    DEBUG    choreographer.channels.pipe:pipe.py:179 Total loops: 1, Final size: 6.
    DEBUG    choreographer._brokers._async:_async.py:124 Error in readloop. Will post a close() task.
    DEBUG    choreographer._brokers._async:_async.py:129 PipeClosedError caught
    INFO     choreographer.browser_async:browser_async.py:243 Closing browser.
    DEBUG    choreographer.browser_async:browser_async.py:245 Cancelling watchdog.
    DEBUG    choreographer.browser_async:browser_async.py:250 Starting browser close methods.
    DEBUG    choreographer.browser_async:browser_async.py:215 Trying Browser.close
    DEBUG    choreographer.protocol.devtools_async:devtools_async.py:90 Cmd 'Browser.close', param keys '', sessionId ''
    DEBUG    choreographer._brokers._async:_async.py:246 Broker writing Browser.close with key ('', 1)
    DEBUG    choreographer._brokers._async:_async.py:255 Created future: ('', 1) <Future pending>
    DEBUG    choreographer.browser_async:browser_async.py:308 Watchdog full shutdown (in finally:)
    DEBUG    choreographer._brokers._async:_async.py:271 Future for ('', 1) deleted.
    DEBUG    choreographer.browser_async:browser_async.py:221 Can't send Browser.close on close channel
    DEBUG    choreographer.browser_async:browser_async.py:252 Browser close methods finished.
    DEBUG    choreographer._brokers._async:_async.py:94 Cancelling message futures
    DEBUG    choreographer._brokers._async:_async.py:99 Cancelling read task
    DEBUG    choreographer._brokers._async:_async.py:103 Cancelling subscription-futures
    DEBUG    choreographer._brokers._async:_async.py:110 Cancelling background tasks
    DEBUG    choreographer.browser_async:browser_async.py:257 Broker cleaned up.
    DEBUG    choreographer.browser_async:browser_async.py:261 Logging pipe closed.
    DEBUG    choreographer.browser_async:browser_async.py:263 Browser channel closed.
    INFO     choreographer.utils._tmpfile:_tmpfile.py:156 TemporaryDirectory.cleanup() worked.
    INFO     choreographer.utils._tmpfile:_tmpfile.py:180 shutil.rmtree worked.
    DEBUG    choreographer.browser_async:browser_async.py:265 Browser implementation cleaned up.
  */
  disabledTests = [
    "test_context"
    "test_no_context"
    "test_watchdog"
  ];

  pythonImportsCheck = [ "choreographer" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Remote control of browsers from Python";
    homepage = "https://github.com/plotly/choreographer";
    changelog = "https://github.com/plotly/choreographer/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
