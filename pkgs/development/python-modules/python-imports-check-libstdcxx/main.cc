#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <condition_variable>
#include <mutex>
#include <thread>

#ifndef LOAD_LIBSTDCXX_MODULE_NAME
#error Missing -DLOAD_LIBSTDCXX_MODULE_NAME
#endif

PYBIND11_MODULE(LOAD_LIBSTDCXX_MODULE_NAME, m) {
  m.doc() = R"pbdoc(
        This module doesn't do anything,
        it only makes the python interpreter load a libstdc++.
        Nixpkgs uses this to ensure that their python packages do not segfault just because of order of imports
    )pbdoc";

  // Make sure we actually require some symbols from libstdc++
  // E.g. earlier we've observed the combination of [ "torch" "zmq" ]  fail
  // because of std::condition_variable
  m.def("dummy", []() {
    // Copy-pasted from
    // https://en.cppreference.com/w/cpp/thread/condition_variable
    //
    std::mutex mutex;
    std::condition_variable cv;
    bool ready = false;
    bool processed = false;

    std::thread worker([&]() {
      std::unique_lock guard(mutex);
      cv.wait(guard, [&] { return ready; });
      processed = true;
      guard.unlock();
      cv.notify_one();
    });

    {
      std::scoped_lock guard(mutex);
      ready = true;
    }
    cv.notify_one();
    {
      std::unique_lock guard(mutex);
      cv.wait(guard, [&] { return processed; });
    }

    worker.join();
  });
}
